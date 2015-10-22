class CoursesController < ApplicationController

    def json

        courses = Course.all
        courses = courses.collect { |course| course.name }

        respond_to do |format|
            format.json { render :json => courses }
        end

    end

end
