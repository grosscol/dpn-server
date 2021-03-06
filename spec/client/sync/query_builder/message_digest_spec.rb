# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.


require 'rails_helper'

describe Client::Sync::QueryBuilder::MessageDigest do
  before(:each) do
    @last_success = Time.now
    @query = Client::Query.new :digests, {
      after: @last_success
    }
  end

  let(:query_builder) { Client::Sync::QueryBuilder::MessageDigest.new("us", "them") }

  it "builds the correct queries" do
    queries = query_builder.queries(@last_success)
    expect(queries).to contain_exactly(@query)
  end
end