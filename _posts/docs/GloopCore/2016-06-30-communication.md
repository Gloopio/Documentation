---
layout: default
category: cor
title: "Communication"
---

# Communication

The communication with the core is done with JSON. 

## Store

Create store:

```c++
Store *store = Store::getStore(json storeSchema);
```

Example of a JSON store schema:

```json
{
    "name":"Default",
    "path":"/Data/Documents/databasePath/",
    "remote_url":"localhost",
    "classes": {
        "Book": {
            "attributes": { "root_object_name":"Book" },
            "metadata": {"orig_lang":"obj-c"},
            "properties": {
                "Number": {
                    "type":"Number",
                    "metadata": { "owner_class":"GloopObject" },
                    "attributes": { "primary_key":true }
                },
                "Title": {
                    "type":"String",
                    "metadata": {},
                    "attributes": { "indexed":true }
                },
                "Author": {
                    "type":"String",
                    "metadata": {},
                    "attributes": { "not_null":true }
                }
            }
        },
        "Person": {
            "attributes": { "root_object_name":"Person" },
            "metadata": {"orig_lang":"obj_c"},
            "properties": {
                "Age": {
                    "type":"Number",
                    "metadata": { "owner_class":"Person" },
                    "attributes": { "indexed":true }
                }
            }
            
        }
    }
}
```

## Save

```c++
store->save(json);
```

```json
{
  "Book": [
    {
      "Number": 1,
      "Title": "The Bible",
      "Author": "Rob"
    },
    {
      "Number": 2,
      "Title": "The Book",
      "Author": "Alex"
    }
  ],
  "Person": [
    {
      "Age": 23
    }
  ]
}
```

or 

```c++
store->saveGloopObject(GloopObject*);
```

## Query
```c++
json result = store->query(json);
```
```json
{
    "columns": [ "Number", "Title", "Author" ], // optional
    "from":"Book",
	"where":"Author = 'Rob'", // optional
    "order_by": ["Author ASC", "Number DESC"], // optional
    "limit": 10, // optional
    "offset":10, // optional
}
```
or 

```c++
GloopObjectArray *result = store->queryForGloopObject(json);
```


## Delete

```c++
bool result = store->remove(json);
```

```json
{
    "from":"Book",
    "where":"Author = 'Alex'"
}
```