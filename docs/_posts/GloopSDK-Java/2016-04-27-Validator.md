---
layout: default
category: jav
title: "Validator"
---

# Validator 

Validators can be used to validate the value of properties before saveing. If the validation fails, a `GloopValidationException` is thrown.

You can use one of the predefined validators or define your own one.

## Predefined validators

Some predefined validators:

- `@Between(min = 5, max = 10)` checks if the value is between the min and max value set.
- `@NotNull` checks if the value set is not null
- `@Past` checks if the date is in the passt
- `@Regex(String)` checks if the value of the property matches the passed regex string

example:

```java
public class Person extends GloopObject {

	@NotNull
	private String name;
	
	@Regex("^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$;")
	private String email;
	
	@Past
	private Date birthdate;
	
	@Between(min = 5, max = 10)
	private int number;

}
```

## Create own validators

In the following example we will create a between validator.

Firs create a `Between` annotation

```java
@Target({FIELD})
@Retention(RUNTIME)
@Constraint(validatedBy = BetweenValidator.class)
@Documented
public @interface Between {

    int min() default 0;

    int max() default Integer.MAX_VALUE;
}
``` 

With the `@Constriant` we can set the validator class witch is responsible for validating the value of the field.

Create a `BetweenValidator` class:

```java
public class BetweenValidator extends GloopValidator<Between, Integer> {

    private int min;
    private int max;

    @Override
    public void initialize(Between constraintAnnotation) {
        this.min = constraintAnnotation.min();
        this.max = constraintAnnotation.max();
    }

    @Override
    public boolean isValid(Integer object) {
        return object != null && object > min && object < max;
    }
    
    @Override
    public String errorMessage() {
        return "String does not match the regular expression";
    }
}
```

To create the validator extend the `GloopValidator<ANNOTATION, TYP_OF_FIELD>` class.

First the `initialize` method is called to get the data from the annotation. In this example we will extract the min and max value out of the annotation. After initialize is finished the `isValid` method is called. Now we have to check if the value of the property is valid. The parameter `object` contains the value of the field. Return true if the data is valid otherwise return false. By overriding the `errorMessage` you can return a custom error message that is shown when the `isValidate` returns false.

Use the new validator by adding `@Between(min = 5, max = 10)` annotation to the desired property of your GloopObject.
