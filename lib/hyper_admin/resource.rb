module HyperAdmin
  class Resource
    attr_reader :resource_class

    def initialize(resource_class)
      @resource_class = resource_class
    end

    def resource_name
      @resource_class.model_name
    end

    def controller_name
      "#{resource_name.plural.camelize}Controller"
    end
  end
end
