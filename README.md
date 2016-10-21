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

## Step 2: Add a Post scaffold

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

## Step 3: Add root route

We have our post scaffold, but when we visit `http://localhost:3000/`, we still see the getting start page.
Let's fix that by setting the "root route" in `config/routes.rb`.

```ruby
Rails.application.routes.draw do
  resources :posts

  root to: "posts#index"
end
```

Now we can visit `http://localhost:3000/` and see the list of posts.

## Step 4: Styling posts

We have some basic blog functionality, but it does not look pretty.
Let's add some styles.

This involves writing some HTML and CSS which builds on what we learned in Coding I.

Let's start in `app/views/posts/index.html.erb`

```erb
<h1>Posts</h1>

<% @posts.each do |post| %>
  <h2><%= post.title %></h2>
  <p><%= post.body %></p>
  <p><%= link_to "Read more", post %></p>
<% end %>

<%= link_to 'New Post', new_post_path %>
```

And then we can edit `app/view/posts/show.html.erb`

```erb
<h1><%= @post.title %></h1>
<p><%= @post.body %></p>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

Lets add a site wrapper to `app/views/layouts/application.html.erb`.

```erb
<div class="wrapper">
  <%= yield %>
</div>
```

Finally, let's delete `app/assets/scaffolds.scss` and stick some new styles in `app/assets/application.css`.

```css

html {
  font-family: helvetica;
}

a {
  color: royalblue;
}

a:hover {
  text-decoration: none;
}

.wrapper {
  margin: 50px auto;
  width: 900px;
}
```
