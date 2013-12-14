module FactoriesModule

  def load_defined_permissions
    Permission.defined_permissions.each do | name |
      if name == 'REGULATION_ADMIN'
        FactoryGirl.create(:permission, name: name, regulation_specific: 1)
      else
        FactoryGirl.create(:permission, name: name, regulation_specific: 0)
      end
    end
    Permission.reset
  end

  def load_defined_regulations
    Regulation.defined_regulations.each do | name |
      FactoryGirl.create(:regulation, name: name, title: "A regulation about #{name}")
    end
    Regulation.reset
  end

  def load_defined_sections
    Section.defined_sections.each do | name |
      FactoryGirl.create(:section, name: name, title: "A section with name #{name}")
    end
  end

end

World(FactoriesModule)
