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

## Step 5: Add comments

Now we have a blog that is looking pretty nice. Let's add commenting.
Comments don't need all the functionality of a scaffold, so let's bootstrap them ourselves.

We can start by generate a model and a controller for comments:

```shell
rails g model Comment body:text author_name:string post_id:integer
rails g controller comments create
rails db:migrate
```

Then we'll want to wire up the routes for our new comments controller.
In `config/routes.rb` add:

```ruby
resources :posts do
  resources :comments, only: :create
end
```

We need to setup the relationship between comments and posts in the `app/models/comment.rb`:

```ruby
class Comment < ApplicationRecord
  belongs_to :post
end
```

...and in `app/models/post.rb`

```ruby
class Post < ApplicationRecord
  has_many :comments
end
```

Now let's flesh out the create action in `app/controllers/comments_controller.rb`.

```ruby
def create
  @comment = Comment.new(comment_params)
  @comment.post = Post.find(params[:post_id])

  if @comment.save
    redirect_to @comment.post, notice: 'Comment was successfully created'
  else
    render "post/show"
  end
end

def comment_params
  params.require(:comment).permit(
    :body,
    :author_name,
  )
end
```

Finally, we need to add views for comments:

In `app/views/posts/index.html.erb`, let's show how many comments each post has:

```erb
<% @posts.each do |post| %>
  <h2><%= post.title %></h2>
  <p><%= post.body %></p>
  <p><%= pluralize post.comments.count, "comment" %>
  <p><%= link_to "Read more", post %></p>
<% end %>
```

In `app/views/posts/show.html.erb`, let's show the comments on a post and add a new form to add a new comment:

```erb
<h2>Comments</h2>

<% @post.comments.each do |comment| %>
  <h5><%= comment.author_name %> said: </h5>
  <p><%= comment.body %></p>
<% end %>

<h4>New Comment:</h4>

<%= form_for([@post, @comment]) do |f| %>
  <div class="field">
    <%= f.label :author_name %><br/>
    <%= f.text_field :author_name %>
  </div>

  <div class="field">
    <%= f.label :body %><br/>
    <%= f.text_area :body %>
  </div>

  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

In order to use `@comment` in the view we need to add it to the posts controller's `show` method in `app/controllers/posts_controller.rb`:

```ruby
def show
  @comment = Comment.new
end
```
## Step 6: Setup authentication

Our blog is looking good, but anyone can add posts which is not what we want.
Let's use the [Devise gem](https://github.com/plataformatec/devise) to protect those pages with a username / password.

First, we'll add the Devise gem to the Gemfile.

```ruby
gem "devise"
```

Next, let's run `bundle install` on the command line to install the gem.
Then, we'll run `rails generate devise:install` to add Devise to our app.

```shell
bundle install
rails generate devise:install
```

Let's add alerts and notices to our layout in `app/views/layout/application.html.erb` so errors will display properly:

```erb
<div class="wrapper">
  <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>
  <%= yield %>
</div>
```

Now that Devise is all setup, we need to generate an `Author` model to handle the author's data.
To do that, let's run the following on the command line:

```shell
rails generate devise Author
rails db:migrate
```

Now, we can start our server and go to `http://localhost:3000/authors/sign_up` to create an account.
We can also visit `http://localhost:3000/authors/sign_in` if we aren't signed in to sign in.

Let's add some UI to handle sign ins and sign outs.
In `app/views/layouts/application.html.erb`:

```erb
<div class="wrapper">
  <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>

  <% if author_signed_in? %>
    Signed in as <%= current_author.email %>.
    <%= link_to "Sign out", destroy_author_session_path, method: :delete %>
  <% else %>
    <%= link_to "Author sign in", new_author_session_path %>
  <% end %>

  <%= yield %>
</div>
```

## Step 7: Protect new / edit post views

We have Sign in / sign out for Authors, but currently that doesn't do anything.

Let's go ahead and disable registrations so people can't sign up for new accounts.

In `app/models/author.rb`, let's remove `:registerable`:

```ruby
class Author < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
end
```

Now we'll see an error if we try to visit `http://localhost:3000/authors/sign_up`.

Next, let's protect the new, edit, update, create, and destroy actions in our posts controller at `app/controllers/posts_controller.rb`:

```ruby
before_action :authenticate_author!, only: [:new, :edit, :update, :create, :destroy]
```

Now if we try to edit or remove a post we'll see a message telling us to sign in first.

Finally, let's hide the new / edit links for people who are not signed in.

In `app/views/posts/index.html.erb`:

```erb
<% if author_signed_in? %>
  <%= link_to 'New Post', new_post_path %>
<% end %>
```

...and in `app/views/posts/show.html.erb`:

```erb
<% if author_signed_in? %>
  <%= link_to 'Edit', edit_post_path(@post) %> |
  <%= link_to 'Back', posts_path %>
<% end %>
```

And that's it. Now we have a functioning blog!
