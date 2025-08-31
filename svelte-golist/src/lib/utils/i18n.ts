import { writable, derived } from 'svelte/store';
import { browser } from '$app/environment';

interface Translations {
  [key: string]: string;
}

interface LocaleData {
  [locale: string]: Translations;
}

const translations: LocaleData = {
  en: {
    save: 'Save',
    cancel: 'Cancel',
    edit_item: 'Edit Item',
    edit_list: 'Edit List',
    confirm_delete_list: 'Do you really want to delete this list?',
    my_lists: 'My Lists',
    create_new_list: 'Create New List',
    name: 'Name',
    amount: 'Amount',
    default_name: 'Shopping List',
    what_to_buy: 'What do you want to buy?',
    settings: 'Settings',
    language: 'Language',
    about: 'About GoList',
    version: 'Version',
    privacy_policy: 'Privacy Policy',
    privacy_policy_url: 'https://golist.ge1ger.de/privacy_policy_en',
    source_code: 'Source Code',
    connection_failed: 'GoList is offline'
  },
  de: {
    save: 'Speichern',
    cancel: 'Abbrechen',
    edit_item: 'Artikel bearbeiten',
    edit_list: 'Liste bearbeiten',
    confirm_delete_list: 'Möchten Sie diese Liste wirklich löschen?',
    my_lists: 'Meine Listen',
    create_new_list: 'Neue Liste erstellen',
    name: 'Name',
    amount: 'Menge',
    default_name: 'Einkaufsliste',
    what_to_buy: 'Was möchten Sie kaufen?',
    settings: 'Einstellungen',
    language: 'Sprache',
    about: 'Über GoList',
    version: 'Version',
    privacy_policy: 'Datenschutzerklärung',
    privacy_policy_url: 'https://golist.ge1ger.de/privacy_policy_de',
    source_code: 'Quellcode',
    connection_failed: 'GoList ist offline'
  },
  es: {
    save: 'Guardar',
    cancel: 'Cancelar',
    edit_item: 'Editar artículo',
    edit_list: 'Editar lista',
    confirm_delete_list: '¿Realmente quieres eliminar esta lista?',
    my_lists: 'Mis listas',
    create_new_list: 'Crear nueva lista',
    name: 'Nombre',
    amount: 'Cantidad',
    default_name: 'Lista de compras',
    what_to_buy: '¿Qué quieres comprar?',
    settings: 'Configuración',
    language: 'Idioma',
    about: 'Acerca de GoList',
    version: 'Versión',
    privacy_policy: 'Política de privacidad',
    privacy_policy_url: 'https://golist.ge1ger.de/privacy_policy_es',
    source_code: 'Código fuente',
    connection_failed: 'GoList está desconectado'
  }
};

export const currentLocale = writable<string>('en');

export const t = derived(currentLocale, ($locale) => {
  return (key: string, params?: Record<string, any>): string => {
    const translation = translations[$locale]?.[key] || translations.en[key] || key;
    
    if (params) {
      return Object.entries(params).reduce((text, [param, value]) => {
        return text.replace(new RegExp(`{${param}}`, 'g'), String(value));
      }, translation);
    }
    
    return translation;
  };
});

export function setLocale(locale: string): void {
  if (translations[locale]) {
    currentLocale.set(locale);
    if (browser) {
      localStorage.setItem('golist_locale', locale);
    }
  }
}

export function initializeLocale(): void {
  if (!browser) return;
  
  const savedLocale = localStorage.getItem('golist_locale');
  const browserLocale = navigator.language.split('-')[0];
  const locale = savedLocale || (translations[browserLocale] ? browserLocale : 'en');
  
  currentLocale.set(locale);
}

export const supportedLocales = Object.keys(translations);

export const localeNames: Record<string, string> = {
  en: 'English',
  de: 'Deutsch',
  es: 'Español'
};