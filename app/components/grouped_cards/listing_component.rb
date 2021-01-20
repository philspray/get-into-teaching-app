module GroupedCards
  class ListingComponent < ViewComponent::Base
    def initialize(data)
      @data = data
    end

    def groups
      @data.keys
    end

    def group_link_anchor(group)
      "group--" + group.parameterize
    end

    def items(group)
      @data[group]
    end
  end
end
