# Coding Level II Preview

This project provides a preview of the Futures Fund Level II Curriculum.
This app represents the kind of work students will do throughout the Level II program.

# Building this App

## Prerequisites:

This guide assumes you have Ruby 2.3 and Rails 5 installed on your machine.

## Step 1: Generate a new app

To start, use `rails new` on the command line to generate a new app:

```shell
rails new coding-2-preview
```

You should be able to startup the app with `rails server` and see it live at `http://localhost:3000`.

# Step 2: Add a Post scaffold

The next step is to build out a scaffold for blog posts.

```shell
rails generate scaffold Post title:string body:text
```

Then perform a migration so these changes will be applied to the database:

```shell
rake db:create
rake db:migrate
```

You should now be able to restart the app with `rails server` and visit `http://localhost:3000/posts` to see the functionality we've added.
