# frozen_string_literal: true

# Context to include to get request DSL improvment
RSpec.shared_context 'ryquest helper' do # rubocop:disable Metrics/BlockLength
  let(:headers) { nil }
  let(:params) { nil }

  # Execute request described in example description and return #response value.
  # Example description must be formated as: "VERB /path".
  #
  # Request will not be launch if it not exist or response already have a value.
  #
  # VERB can be: GET, POST, PUT, PATCH, DELETE
  #
  # To add specific body or headers define them with `let(:headers/:params) { { key: :value } }
  #
  # Params path can be send as: 'VERB /path/:param',
  # :param will be replaced by `param` value (let, method, ...) or their `id` value.
  #
  # @return [ActionDispatch::TestResponse] the #response value
  def response!
    match = match_verb
    return response if response || match.nil?

    verb = match[1]
    path = match[2]

    send verb.downcase, build_path(path), params: params, headers: headers
    response
  end

  # @return [Hash] the #response!.body parsed from json
  def json!; JSON.parse response!.body end

  private

  # Find request http verb and path in the parents example description.
  # @return [MatchData] verb in [0] path in [1]
  def match_verb
    match = nil

    self.class.parent_groups.each do |parent|
      match = parent.description.match /^(GET|POST|PATCH|PUT|DELETE) (.+)/
      break if match
    end

    match
  end

  # Replace params path with their value.
  # Use param path #id if present.
  # @return [String]
  def build_path path
    return path if path.exclude? ':'

    path.scan(/:(\w+\b)/).flatten.each do |match|
      value = send match
      value = value.id if value.respond_to? :id

      path = path.gsub ":#{match}", value.to_s
    end

    path
  end
end

# Include the context when using the type: :request option
RSpec.configure { |config| config.include_context 'ryquest helper', type: :request }
