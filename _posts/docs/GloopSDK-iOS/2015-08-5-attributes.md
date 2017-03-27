## Attributes

Attributes are used to customize how Gloop works, and are applicable to many differnt components of Gloop. This is a reference of all the attributes. 

For examples, see the relevant sections in the rest of this guide.


###Attribute Types
#####Tag Attributes
Tags are just labels that can be applied to a store, class or property, for example to `ignore` a property on a Class we tag that property with the `ignore` tag.

##Store Attributes
| Name | Type | Description | Default Value |
|:---:|:---:|:---|:---|
| directory  | string | Directory where this store will be saved | default\_docs\_dir |
| server  | string | Backend server address connected to this store | localhost |
| api_key | string | The key used to connect to the server | |

#### Setting Store Attributes

##Class and Property Attributes

###Class Attribute Reference

| Name | Type | Description | Default Value |
|:---:|:---:|:---|:---:|
| use_ivars | Boolean | Treat this classes Ivars like properties | false |
| use_properties | Boolean | Treat this classes Ivars like properties | true |
| ignore | Tag | Ignore this class | n/a |
| target_store  | String | GloopObjects created from this class will save in the target_store | default_store |
| acl  | String | ACL used for any GloopObjects created from this class | default_acl |
| version  | Integer | Used in migration to keep track of the version of the class | 1 |

###Property Attribute Reference
| Name | Type | Description | Default Value |
|:---:|:---:|:---|:---:|
| ignored | Tag | Ignore this property | n/a |
| indexed | Tag | Index this property | n/a |
| unique | Tag | The value of this property must be unique | n/a |
| not_null  | Tag | The value of this property cannot be null | n/a |
| primary\_key  | Tag | | n/a |
| serializer  | String | Specifies which serializer should be used | default_serializer |


### Setting Class and Property Attributes

### Header defined attributes
The attributes on properties and classes can be defined from within the header. This is useful, because at a glance the header file gives an accurate reflection of the entire class, and how its configured.

Class attributes can be defined anywhere inside the interface with the `class_attributes()` function.
Property attributes are defined alongside standard Objective-C property attributes.

```objective-c
@interface Book : GLPObject

class_attributes(use_ivars(true), version(4)) // The class attributes are defined here

/* Each properties attributes are defined where the regular Objective-C property attributes are also defined */
@property (nonatomic, indexed) 						NSString *title;
@property (nonatomic, serializer(AuthorSerializer)) NSString *author;

@end
```


Although unlikley, it is possible for these header defined attributes to interfere with other tools. They can be disabled on a file by file basis with;

```objective-c
#define GLP_HEADER_GENERATED_ATTRIBUTES false
```
at the top of the header file (and other methods can be used to set the attributes, see below). 


### Setting attributes without using the header
