# encoding: utf-8
require 'spec_helper'

describe 'users with interactive shells' do
  before :all do
    @dr = 'docker run --rm -t jumanjiman/tftp'
  end

  it 'should only include "root" and "user"' do
    # Which interactive shells are allowed in container?
    shells = `#{@dr} cat /etc/shells 2> /dev/null`.split($RS)
    shells.map!(&:chomp).reject! { |s| s.match %r{/sbin/nologin} }

    # Which users have an interactive shell?
    users = []
    records = `#{@dr} getent passwd 2> /dev/null`.split($RS)
    records.each do |r|
      fields = r.split(':')
      users << fields[0] if shells.include?(fields[6].chomp)
    end

    users.should =~ %w(root user)
  end
end
