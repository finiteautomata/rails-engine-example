Rails.application.routes.draw do
  mount Mathmath::Engine => "/mathmath"
end
