#!/usr/bin/env ruby

require "sinatra"
require "json"
require "neo4j/core"
require "neo4j/core/cypher_session/adaptors/http"

adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.new("http://neo4j:adminadmin@localhost:7474")
session = Neo4j::Core::CypherSession.new(adaptor)

get "/objs/:label/:field/:value" do
  results = session.query("MATCH (found:#{params["label"]} { #{params["field"]}: \"#{params["value"]}\" }) RETURN found")

  content_type "application/json"
  results.map { |person| person.found.props }.to_json
end

get "/detail/:label/:field/:value" do
  results = session.query("MATCH (found:#{params["label"]} { #{params["field"]}: \"#{params["value"]}\" })-[rel]-(other) RETURN found, rel, other")

  content_type "application/json"
  results.map do |person|
    puts person.inspect
    {
      self: person.found.props.merge(label: person.found.labels.first),
      rel: person.rel.props.merge(type: person.rel.type),
      other: person.other.props.merge(label: person.other.labels.first),
    }
  end.to_json
end
