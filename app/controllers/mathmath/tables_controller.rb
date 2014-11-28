require_dependency "mathmath/application_controller"

module Mathmath
  class TablesController < ApplicationController
    respond_to :json

    def show
      multiplier = Integer(params[:id])

      tables = Hash[(1..10).collect {|x| ["#{x}x#{multiplier}", x * multiplier]}]

      respond_with tables
    rescue ArgumentError
      respond_with({error: "#{params[:id]} is not a valid multiplier"})
    end
  end
end
