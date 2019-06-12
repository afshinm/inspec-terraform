# inspec-infratest
Unit testing for your "Infrastructure as code"

## Requirements

 - Terraform > 0.12
 - Inspec > 4.0

## Example

```ruby
describe terraform(resource_name: 'google_compute_instance\..*') do
  it { should exist }
  its("type") { should eq "google_compute_instance" }
end
```

