Copyright 2024 The Isolator Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Overview

The purpose of this page is to outline some design principles to follow when
helping to make contributions to Isolator.

# Isolator Goal/Purpose

The ultimate goal of Isolator is to allow organizations to create isolated and
secure environment in Google Cloud where they can then collaborate on sensitive
data with other organizations. As new capabilities are built and integrated to
Isolator this may evolve. The main page README and this section will change
if the stated goal/purpose (overall scope) of Isolator changes.

# Principles

## 1 - Simple

There are creative ways to solve many solutions and sometimes complexity cannot
be avoided. However, when considering options and capabilities, keeping our
design simpler is strongly desired.

## 2 - Code as much as possible

Being this is a repo, it is probably obvious but we want to have as much of our
solution and design in code versus manual configuration. Sometimes IaC is not
supported and/or click ops truly is the fastest/best way to handle a configuration.
This should be our last resort.

## 3 - Rationale

Design changes/additions/etc. should all come with clearly outlined rationale.
What risk are we addressing? What capability are we adding and why are we adding
it? In our code and design updates we should link to documentation that helps 
provide additional context and background info so that anyone who wishes to 
learn and understand more has quick/easy access to do so.