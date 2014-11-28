1) Los Engines pueden ser considerados como "subaplicaciones" dentro de una aplicación más grande. De hecho, una aplicación Rails comparte muchísima funcionalidad con un Engine, con lo cual "son casi lo mismo"


Creamos un engine

$ rails plugin --help
Ver las opciones

$ rails plugin new mathmath --full --mountable --skip-test-unit --dummy-path=spec/dummy

2) En engine.rb podemos observar

isolate_namespace Mathmath

"The isolate_namespace method here deserves special notice. This call is responsible for isolating the controllers, models, routes and other things into their own namespace, away from similar components inside the application"

3) El Gemfile y gemspec son idénticos a los de una gema, como explicó Luis en su momento

4) En app/ encontramos las mismas cosas que en una aplicación común y silvestre.

5) En spec/dummy vamos a encontrar una aplicación que utiliza nuestro engine, y nos sirve para probarlo.

Si vemos dentro de su routes.rb, veremos la línea que lo monta..

A su vez, dentro de boot.rb, tenemos esta línea

```
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../../lib', __FILE__)
```

6) Creemos un controller

$ bin/rails g controller tables

con...

```
require_dependency "mathmath/application_controller"

module Mathmath
  class TablesController < ApplicationController
    respond_to :json

    def show
      multiplier = Integer(params[:id])

      tables = Hash[(1..10).collect {|x| ["#{x} * #{multiplier}", x * multiplier]}]

      respond_with tables
    rescue ArgumentError
      respond_with({error: "#{params[:id]} is not a valid multiplier"})
    end
  end
end
```


y agregamos el route.

Lo mostramos

7) Crear modelos

br g model SpecialNumber ...

- Metemos seeds de paso

```
Mathmath::SpecialNumber.create name:"e", value: 2.71828, description: <<-EOS
  The number e is an important mathematical constant that is the base of the natural logarithm. It is approximately equal to 2.71828,[1] and is the limit of (1 + 1/n)n as n approaches infinity, an expression that arises in the study of compound interest. It can also be calculated as the sum of the infinite series[2]
  EOS
```

8) Creamos una nueva app que use nuestro engine

$ rails new newapp

- Agrego en el Gemfile
gem 'mathmath', path: "../mathmath"
o
gem 'mathmath', github: "geekazoid/mathmath"

- Agrego en el routes.rb

mount Mathmath::Engine, at: "mathmath"

- Instalo migraciones
$ bin/rake mathmath:install:migrations

- Agrego ésto (para cargar seeds)
Mathmath::Engine.load_seed

