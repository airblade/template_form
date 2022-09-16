# Template Form - a Rails form builder where you bring your own HTML

Template Form makes defining the HTML your form inputs generate as simple as possible: you just write it out.  Most other form builders, e.g. Simple Form, add a layer of indirection and make you use their own DSL.

Templates are grouped so you can for example define both vertical and horizontal forms, or Bootstrap and Tailwind forms, in the same Rails app.

Right now Template Form includes templates for [Bulma](https://bulma.io/documentation/form/) but in time it will include templates for all the popular CSS frameworks.

Template Form works with all template engines supported by [Tilt](https://github.com/rtomayko/tilt).


### Installation

Add it to your Gemfile:

```
gem 'template_form'
```

And then `bundle install`.


### Example

Let's say you use Bulma.  Here's what your view might look like:

```erb
<%= template_form_with model: Post.new do |f| %>
  <%= f.input :title %>
  <%= f.input :body %>
<% end %>
```

This will be rendered as:

```html
<form action="/users" method="post" data-remote="true">

  <div class="field">
    <label class="label" for="post_title">Title</label>
    <div class="control">
      <input class="input" type="text" name="post[title]" id="post_title">
    </div>
  </div>

  <div class="field">
    <label class="label" for="post_body">Title</label>
    <div class="control">
      <textarea class="textarea" name="post[body]" id="post_body"></textarea>
    </div>
  </div>

</form>
```

Now let's say you want a horizontal form instead.  The only change you need to make is to specify the form type:

```diff
- <%= template_form_with model: Post.new do |f| %>
+ <%= template_form_with model: Post.new, form_type: :bulma_horizontal do |f| %>
```

And then you will get this HTML instead:


```html
<form action="/users" method="post" data-remote="true">

  <div class="field is-horizontal">
    <div class="field-label is-normal">
      <label class="label" for="post_title">Title</label>
    </div>
    <div class="field-body">
      <div class="field">
        <div class="control">
          <input class="input" type="text" name="post[title]" id="post_title">
        </div>
      </div>
    </div>
  </div>

  <div class="field is-horizontal">
    <div class="field-label is-normal">
      <label class="label" for="post_body">Body</label>
    </div>
    <div class="field-body">
      <div class="field">
        <div class="control">
          <textarea class="textarea" name="post[body]" id="post_body"></textarea>
        </div>
      </div>
    </div>
  </div>

</form>
```


### Defining your templates

Your templates live at `/app/forms/<FORM TYPE>/` where `<FORM TYPE>` is a name that makes sense to you, and the value that you use with the `:form_type` option to `#template_form_with`.

They should have these names:

- `text_input.html.erb`
- `textarea_input.html.erb`
- `select_input.html.erb`
- `grouped_select_input.html.erb`
- `checkbox_input.html.erb`
- `date_input.html.erb`

Use whatever extension goes with your template engine.

Inside each template you can use the normal Rails form helpers.  Here's the template for Bulma's [text input](https://github.com/airblade/template_form/blob/master/lib/template_form/templates/bulma/text_input.html.erb):

```erb
<div class="field <%= options.delete(:field_class) %>">

  <% if has_label %>
    <%- label_options[:class] << ' label' %>
    <%- label_options[:class] << ' required' if options.delete(:required) %>
    <%= label attribute_name, label_text, label_options %>
  <% end %>

  <div class="control <%= options.delete(:control_class) %>">
    <%- options[:class] << ' input' %>
    <%- options[:class] << ' is-danger' if errors[attribute_name].present? %>
    <%= text_field attribute_name, options %>
  </div>

  <%- if hint_text.present? %>
    <p class="help"><%= hint_text %></p>
  <%- end %>

  <%- if errors[attribute_name].present? %>
    <p class="help is-danger"><%= errors.full_messages_for(attribute_name).to_sentence %></p>
  <%- end %>

</div>
```

The methods available inside the template are defined in the corresponding [models](https://github.com/airblade/template_form/blob/master/lib/template_form/)' `#render` method.  For example, here is the [text input](https://github.com/airblade/template_form/blob/c80b445a5a50e836635fd1bdf010d32f49902604/lib/template_form/base_input.rb#L28-L42)'s:

```ruby
def render
  template.render(
    builder,
    attribute_name: attribute_name,

    has_label:      has_label,
    label_text:     label_text,
    label_options:  label_options,

    hint_text:      hint_text,

    options:        options,
    errors:         errors
  ).html_safe
end
```

You also have access to the `view` in which the template is contained.  This is handy if you need to call methods on the view inside your template.  For example, translating values for data attributes.

```erb
<div data-controller="foo" data-foo-show-value=view.translate("foo.show")>
</div>
```

### Attribute types and form inputs

Template Form looks up the type for the attribute, falling back to `:string` if it can't find one.  Then it uses the corresponding form input.

 Attribute type | Form input
--|--
 `:string` | `TextInput`
 `:text` | `TextareaInput`
 `:date` | `DateInput`
 `:boolean` | `CheckboxInput`
 `:file` | `FileInput`
 `:select` | `SelectInput`
 `:grouped_select` | `GroupedSelectInput`

You can specify a type to use with `:as`, e.g. `<%= f.input :reason, as: :text %>`.


