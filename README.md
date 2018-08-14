# OpenStack Heat examples

[![Build Status](https://travis-ci.org/syseleven/heat-examples.svg?branch=master)](https://travis-ci.org/syseleven/heat-examples)
[![GitHub license](https://img.shields.io/github/license/syseleven/heat-examples.svg)](https://github.com/syseleven/heat-examples/blob/master/LICENSE)

## What is "Heat"?

Heat is a service to orchestrate multiple composite cloud applications using templates.  
Each template is launched into a so called 'heat stack'.

## What are these examples for?

These heat examples are meant to assist you while getting started with cloud computing.

## Are these templates suitable for production?

This library demonstrates certain aspects of deployment with heat but does not contain complete code that is suitable for production.

## Getting Started

To work through these examples you need to install OpenStack command line clients as described here:  
[http://docs.openstack.org/user-guide/content/install_clients.html](http://docs.openstack.org/user-guide/content/install_clients.html)

or

You can build your own environment using the [gettingStarted](gettingStarted/README.md) template.
This template is prepared to be used as a copy & paste file that you can use within the openstack dashboard. The only needed parameter is either "key_name" where you insert the name of your public SSH key or "ssh-keys" where you insert your SSH key directly.

## Support / Liability

Even if SysEleven maintains this library we do not provide support for its content.

## Contribution

We welcome contributions and fixes for our IaC Examples library. Just commit your code, run lint tests (see below) and open a pull request.

## Development

- Install required packages `npm install`
- Run `npm run lint` to ensure that there are no syntax errors and that a README.md and .yaml file(s) is/are present, before creating a pull request.
