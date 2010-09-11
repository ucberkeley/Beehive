class CategoriesController < ApplicationController

    def json
        cats = Category.find(:all)
        cats = cats.collect { |cat| cat.name }

        respond_to do |format|
            format.json { render :json => cats }
        end

    end

end
