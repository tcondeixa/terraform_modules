# terraform_modules
Example of using a modular approach for terraform to cope with agile teams using micro-services.

All modules can be defined for several providers and they have a version assigned.
However most of the changes can be done without breaking changes and without increasing the version.

## Basic Modules
Simple modules used as the base to create composed modules.
This modules provide some logic and dynamic blocks for a few number of resources, but there is no naming assumptions.
This modules does not have any constraint on the way the system architecture and environments are organised.
The module can easily evolve adding more features and exposing new variables for inputs and output.

## Composed Modules
Composed modules to be user by micro-services.
This modules provide logic to deal with the way the development process, environments and architecture is designed.
The main idea is to provide a high level abstraction about the infrastructure and platform.
Product teams should be able to be autonomous to easily deploy the resources they need without compromising on quality.
