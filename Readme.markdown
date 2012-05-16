#Simple authorisation for Rails

##Installation

Add the following to your gem file:

```
gem 'checkpoint'
```
and then run bundle install from your shell.

## How to use

By default all users get denied access to everything.

To enable a user to access/use a resource you must specify an authorisation rule to grant access. This is done using the "authorise" (or "authorize" for americans) method in the application controller.

So if for instance you wanted to grant access (to all users) to your posts index action you could do the following:

```ruby
#grant access your posts controller 'index' action to all users
authorise "PostsController::index"

#or  authorize "PostsController::index"

```

Noticed how the pattern above is in the format of "ControllerName::action"

So if you wanted to grant action to your posts view action you could do the following:

```ruby
#grant access your posts controller 'view' action to all users
authorise "PostsController::view"
```

If you want to grant access to all actions in your post controller you can use a wildcard ('*') char and do the following

```ruby
#grant access your posts controller actions to all users
authorise "PostsController::*"
```

You can also do the same above by using a regular expression:

```ruby
#grant access your posts controller actions to all users
authorise /\APostsController::.*\Z/
```

If you want to be able to grant access to your view action to only users who have signed in, you can do this by passing a block that returns true if the user is logged in.

```ruby
#grant access your posts controller 'view' action to all users who have signed in
authorise "PostsController::view" do
  !current_user.nil?
end
```

In the example above the block uses the bindings of the controller that is being called, so therefore it can access anything that that particular controller access e.g. your current params hash etc...

Similarly you could grat access to everything to all admin users by doing the following:

```ruby
#grant access to everything to all admin users
authorise "*" do
  !current_user.nil? && current_user.admin?
end
```

Finally by passing an array you can authorise a range of controller actions in one go:

```ruby
#grant access your posts controller 'create' and 'update' actions to all users who have signed in
authorise ["PostsController::create", "PostsController::update"] do
  !current_user.nil?
end
```

## FAQ

### How do I enable devise?

```ruby
authorise "Devise::*"

```

## License

Checkpoint is released under the MIT license:

* http://www.opensource.org/licenses/MIT
