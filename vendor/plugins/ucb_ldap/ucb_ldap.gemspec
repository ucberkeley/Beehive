# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ucb_ldap}
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steven Hansen, Steve Downey, Lucas Rockwell"]
  s.date = %q{2010-08-03}
  s.description = %q{Convenience classes for interacing with UCB's LDAP directory}
  s.email = %q{runner@berkeley.edu}
  s.extra_rdoc_files = ["README", "lib/person/adv_con_person.rb", "lib/person/affiliation_methods.rb", "lib/person/generic_attributes.rb", "lib/ucb_ldap.rb", "lib/ucb_ldap_address.rb", "lib/ucb_ldap_affiliation.rb", "lib/ucb_ldap_entry.rb", "lib/ucb_ldap_exceptions.rb", "lib/ucb_ldap_namespace.rb", "lib/ucb_ldap_org.rb", "lib/ucb_ldap_person.rb", "lib/ucb_ldap_person_job_appointment.rb", "lib/ucb_ldap_schema.rb", "lib/ucb_ldap_schema_attribute.rb", "lib/ucb_ldap_service.rb", "lib/ucb_ldap_student_term.rb"]
  s.files = ["CHANGELOG", "Manifest", "README", "Rakefile", "TODO", "lib/person/adv_con_person.rb", "lib/person/affiliation_methods.rb", "lib/person/generic_attributes.rb", "lib/ucb_ldap.rb", "lib/ucb_ldap_address.rb", "lib/ucb_ldap_affiliation.rb", "lib/ucb_ldap_entry.rb", "lib/ucb_ldap_exceptions.rb", "lib/ucb_ldap_namespace.rb", "lib/ucb_ldap_org.rb", "lib/ucb_ldap_person.rb", "lib/ucb_ldap_person_job_appointment.rb", "lib/ucb_ldap_schema.rb", "lib/ucb_ldap_schema_attribute.rb", "lib/ucb_ldap_service.rb", "lib/ucb_ldap_student_term.rb", "schema/schema.yml", "ucb_ldap.gemspec", "version.yml"]
  s.homepage = %q{http://ucbrb.rubyforge.org/ucb_ldap}
  s.rdoc_options = ["-o doc --inline-source -T hanna lib/*.rb"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ucbrb}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Convenience classes for interacing with UCB's LDAP directory}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-net-ldap>, [">= 0.0.4"])
    else
      s.add_dependency(%q<ruby-net-ldap>, [">= 0.0.4"])
    end
  else
    s.add_dependency(%q<ruby-net-ldap>, [">= 0.0.4"])
  end
end
