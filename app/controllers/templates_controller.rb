class TemplatesController < ApplicationController

def index
  @images = Image.all
end

def new
end

def create
  #create new template name, fields template, field
  
  #Create a new template
  @template = Template.new(template_name: JSON.parse(params['templateName']))
  @template.save

  
  byebug
end

def show
end




end