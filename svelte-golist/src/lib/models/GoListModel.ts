import { v4 as uuidv4 } from 'uuid';

export abstract class GoListModel {
  id: string;
  name: string;
  deleted: boolean;
  modified: Date;

  constructor({
    id,
    name,
    deleted = false,
    modified
  }: {
    id?: string;
    name: string;
    deleted?: boolean;
    modified?: Date;
  }) {
    this.id = id || uuidv4();
    this.name = name;
    this.deleted = deleted;
    this.modified = modified || new Date();
  }

  toJson(): Record<string, any> {
    return {
      id: this.id,
      name: this.name,
      deleted: this.deleted,
      modified: this.modified.toISOString()
    };
  }

  abstract merge(other: GoListModel): GoListModel;
  abstract equals(other: GoListModel): boolean;

  protected lastModified(model1: GoListModel, model2: GoListModel): GoListModel {
    return model1.modified > model2.modified ? model1 : model2;
  }
}