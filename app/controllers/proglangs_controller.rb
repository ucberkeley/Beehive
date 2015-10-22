class ProglangsController < ApplicationController

    def json
        proglangs = Proglang.all
        proglangs = proglangs.collect { |proglang| proglang.name }

        respond_to do |format|
            format.json { render :json => proglangs }
        end

    end

end
