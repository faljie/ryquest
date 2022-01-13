# Ryquest

*(d)R(spec)y(re)quest*

Improve `type: :request` DSL provided by `rspec-rails`.

Testing controller with `type: :request` can lead to duplication in description and test.
```ruby
  describe 'GET /path' do
    it 'should ...' do
      get '/path'
      expect(response).to # ...
    end
  end
```

Ryquest remove this duplication by using parents description to setup the test.
```ruby
  describe 'GET /path' do
    it 'should ...' do
      expect(response!).to # ...
    end
  end
```

## Requirements

- ryquest ~> 1.0: rspec-rails ~> 5.0

*Note: ryquest should be able to run with older version of rspec-rails but behaviour is not garented.*

## Installation

1. Add `ryquest` to your application in `:test` env
  ```ruby
    gem 'ryquest', '~> 1.0', require: false, groupe: :test
  ```
2. Setup `ryquest` in `spec/rails_helper.rb` file
  ```ruby
    # Add additional requires below this line. Rails is not loaded until this point!
    require 'ryquest'
  ```

## Usage

### Basic request

Ryquest use parent's description in order to setup the test.
It dig through all the test parents and stop on the first description which can be use to setup a request.

A valid parent's description is compose by:
1. An HTTP verbs: `GET`, `POST`, `PUT`, `PATCH`, `DELETE`
2. A path: `/user/comments`

Use `response!` to launch the request and get the result (same than `response` result).
Value is cached so it can be use several time without launch the request again.

```ruby
  describe 'POST /user/comments' do # not used
    describe 'GET /user/comments' do # response! stop here and use this description
      it 'should list user comments' do
        expect(response!).to have_http_status :ok
        expect(JSON.parse(response!.body)).to eq ['comment_1', 'comment_2']

        # equivalent to
        get '/user/comments'

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq ['comment_1', 'comment_2']
      end
    end
  end
```

*Note:*
- *`response!` can launch only one request per test, other request must be setup trought rspec-rails way.*
- *if `get`, `post`, ... is use before `response!`, `response!` will return the `get`, `post`, ... result.*

### With headers and params

To use specific headers and params with `response!`, put their value in `let` variables `headers` and `params`.
`response!` automaticaly include theses values in the request if they exists.

```ruby
  let(:headers) { { 'Authorization' => 'token' } }
  let(:params) { { title: 'lorem', content: 'ipsum' } }

  describe 'POST /user/comments' do
    it 'should create a new comment' do
      expect { response! }.to change { Comment.count }.by 1

      # equivalent to
      expect { post '/user/comments', headers: headers, params: params }.to change { Comment.count }.by 1
    end
  end
```

Params are converted by default to form-urlencoded format.
`Ryquest.configuration.content_type` can change this behaviour.

### With route parameters

`response!` handle route parameters by looking for a `let` variable with the same parameter name.

*Note: if variable have an `id` method it will use it instead convert the variable to string.*

```ruby
  let(:comment) { create :comment }

  describe 'DELETE /user/comments/:comment' do
    it 'should delete the comment' do
      response!

      expect { Comment.find comment.id }.to raise_error ActiveRecord::RecordNotFound

      # equivalent to
      delete "/user/comments/${comment.id}"

      expect { Comment.find comment.id }.to raise_error ActiveRecord::RecordNotFound
    end
  end
```

### Helper

* `json!` call `response!` and return the body parsed into hash from json.
  ```ruby
    describe 'GET /user/comments' do
      it 'should list user comments' do
        expect(json!).to eq ['comment_1', 'comment_2']

        # equivalent to
        get '/user/comments'

        expect(JSON.parse(response.body)).to eq ['comment_1', 'comment_2']
      end
    end
  ```

### Configuration

Configuration can be change with `Ryquest.configuration` or `Ryquest.configure` method.

* `content_type` change how params are converted and sent. Note that it can change CONTENT_TYPE header
  * `:form` (default value) convert to form-urlencoded
  * `:json` convert to JSON, change CONTENT-TYPE to application/json

### TODO

* Permit to pass params and headers into response rather than update params directly
