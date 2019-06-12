require "json"

class Terraform < Inspec.resource(1)
  name 'terraform'
  desc 'Verifies Terraform resource'
  example "
    describe terraform(resource_name: 'google_compute_instance') do
      it { should exist }
    end
  "
  supports platform: 'terraform'

  def initialize(opts = {})
    super()
    if opts[:resource_name]
      @id = :resource_name
      @resource_name = opts[:resource_name]
    end

    @module_name = "root_module"
    if opts[:module_name]
      @module_name = opts[:module_name]
    end

    content = JSON.load inspec.backend.resources.content
    resources = content["planned_values"][@module_name]["resources"].select {
      |values| values["address"].match(@resource_name)
    }

    if resources.one?
      @resources = resources[0]
    else
      @resources = resources
    end
  end

  %w{
    id name type provider_name
  }.each do |property|
    define_method property do
      @resources[property] unless @resources.nil?
    end
  end

  def exists?
    not @resources.nil?
  end

  def to_s
    "terraform resource #{@resource_name}"
  end
end
