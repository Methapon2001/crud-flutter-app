/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("vgqw7o3ww9b3q9x")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "a6vxuycc",
    "name": "status",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("vgqw7o3ww9b3q9x")

  // remove
  collection.schema.removeField("a6vxuycc")

  return dao.saveCollection(collection)
})
