import { ShoppingList } from '../models/ShoppingList.js';
import { ShoppingListCollection } from '../models/collections/ShoppingListCollection.js';
import { HttpMethod } from '../types/index.js';

export class GoListClient {
  private static readonly BACKEND = import.meta.env.VITE_BACKEND || '192.168.178.58:8000';
  private static readonly ENVIRONMENT = import.meta.env.VITE_ENV || 'dev';
  private static readonly API_KEY = import.meta.env.VITE_API_KEY || '123';

  private webSocket: WebSocket | null = null;
  deviceId: string = '';

  get httpProtocol(): string {
    return GoListClient.ENVIRONMENT !== 'dev' ? 'https' : 'http';
  }

  get wsProtocol(): string {
    return GoListClient.ENVIRONMENT !== 'dev' ? 'wss' : 'ws';
  }

  private get headers(): Record<string, string> {
    return {
      'api-key': GoListClient.API_KEY,
      'user-id': this.deviceId,
      'Content-Type': 'application/json'
    };
  }

  private async sendRequest({
    endpoint,
    httpMethod,
    body
  }: {
    endpoint: string;
    httpMethod: HttpMethod;
    body?: any;
  }): Promise<Response> {
    const url = `${this.httpProtocol}://${GoListClient.BACKEND}${endpoint}`;
    let response: Response;
    
    const jsonBody = body ? JSON.stringify(body) : undefined;

    try {
      switch (httpMethod) {
        case HttpMethod.GET:
          response = await fetch(url, { method: 'GET', headers: this.headers });
          break;
        case HttpMethod.POST:
          response = await fetch(url, { method: 'POST', body: jsonBody, headers: this.headers });
          break;
        case HttpMethod.PUT:
          response = await fetch(url, { method: 'PUT', body: jsonBody, headers: this.headers });
          break;
        case HttpMethod.DELETE:
          response = await fetch(url, { method: 'DELETE', body: jsonBody, headers: this.headers });
          break;
        default:
          throw new Error(`Unsupported HTTP method: ${httpMethod}`);
      }
    } catch (error) {
      throw new Error(`${httpMethod} request to '${endpoint}' failed: ${error}`);
    }
    
    if (!response.ok) {
      throw new Error(`${httpMethod} '${url}' failed, response code was ${response.status}`);
    }
    
    return response;
  }

  async createTokenToShareList(shoppingListId: string): Promise<string> {
    const response = await this.sendRequest({
      endpoint: '/tokens',
      httpMethod: HttpMethod.POST,
      body: { shopping_list_id: shoppingListId }
    });
    
    const responseJson = await response.json();
    const token = responseJson.token;
    
    return `${this.httpProtocol}://${GoListClient.BACKEND}/join?token=${token}`;
  }

  async joinListWithToken(token: string): Promise<ShoppingList> {
    const response = await this.sendRequest({
      endpoint: `/tokens/join/${token}`,
      httpMethod: HttpMethod.POST
    });
    
    const json = await response.json();
    return ShoppingList.fromJson(json);
  }

  async getShoppingList(shoppingListId: string): Promise<ShoppingList> {
    const response = await this.sendRequest({
      endpoint: `/shopping-lists/${shoppingListId}`,
      httpMethod: HttpMethod.GET
    });
    
    const json = await response.json();
    return ShoppingList.fromJson(json);
  }

  async getShoppingLists(): Promise<ShoppingListCollection> {
    const response = await this.sendRequest({
      endpoint: '/shopping-lists',
      httpMethod: HttpMethod.GET
    });
    
    const json = await response.json();
    return ShoppingListCollection.fromJson(json);
  }

  async upsertShoppingList(shoppingList: ShoppingList): Promise<void> {
    await this.sendRequest({
      endpoint: '/shopping-lists',
      httpMethod: HttpMethod.PUT,
      body: shoppingList.toJson()
    });
  }

  async deleteShoppingList(shoppingListId: string): Promise<void> {
    await this.sendRequest({
      endpoint: `/shopping-lists/${shoppingListId}`,
      httpMethod: HttpMethod.DELETE
    });
  }

  async listenForChanges(shoppingListId: string): Promise<ReadableStream<ShoppingList>> {
    return new ReadableStream({
      start: (controller) => {
        if (this.webSocket) {
          this.webSocket.close();
        }

        const wsUrl = `${this.wsProtocol}://${GoListClient.BACKEND}/shopping-lists/${shoppingListId}/listen`;
        this.webSocket = new WebSocket(wsUrl);

        this.webSocket.onopen = () => {
          this.webSocket?.send(JSON.stringify(this.headers));
        };

        this.webSocket.onmessage = (event) => {
          try {
            const shoppingListJson = JSON.parse(event.data);
            const shoppingList = ShoppingList.fromJson(shoppingListJson);
            controller.enqueue(shoppingList);
          } catch (error) {
            console.error('Failed to parse websocket message:', error);
          }
        };

        this.webSocket.onerror = (error) => {
          console.error('WebSocket error:', error);
          controller.error(new Error('Failed to connect to websocket'));
        };

        this.webSocket.onclose = () => {
          controller.close();
        };
      },
      cancel: () => {
        this.webSocket?.close();
      }
    });
  }
}