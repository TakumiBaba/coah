'use strict'

module.exports = (grunt) ->

  require 'coffee-script'
  require 'coffee-errors'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-csslint'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-htmlhint'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-concurrent'

  grunt.registerTask 'test', [
    'concurrent:test'
  ]
  grunt.registerTask 'build', [
    'concurrent:build'
  ]
  grunt.registerTask 'buildjs', [
    'coffee:dist', 'coffeelint:client', 'uglify'
  ]
  grunt.registerTask 'buildcss', [
    'stylus:dist', 'csslint:client', 'stylus:release'
  ]
  grunt.registerTask 'buildhtml', [
    'jade:dist', 'htmlhint:client', 'jade:release'
  ]
  grunt.registerTask 'buildstatic', [
    'imagemin'
  ]
  grunt.registerTask 'default', [
    'build', 'test', 'watch'
  ]

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    concurrent:
      test: [ 'coffeelint:server', 'simplemocha' ]
      build: [ 'buildjs', 'buildcss', 'buildhtml', 'buildstatic' ]

    copy:
      dist:
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '!**/*.{jpg,png,gif,coffee,styl,jade}' ]
          #src: [ '!**/*.{coffee,styl,jade}' ]
          dest: 'public/'
        }]

    imagemin:
      dist:
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '**/*.{jpg,png,gif}' ]
          dest: 'public/'
        }]

    coffeelint:
      options:
        max_line_length:
          value: 79
        indentation:
          value: 2
        newlines_after_classes:
          level: 'error'
        no_empty_param_list:
          level: 'error'
        no_unnecessary_fat_arrows:
          level: 'ignore'
      client:
        files: [
          { expand: yes, cwd: 'app/assets/', src: [ '**/*.coffee' ] }
        ]
      server:
        files: [
          { expand: yes, cwd: 'app/events/', src: [ '**/*.coffee' ] }
          { expand: yes, cwd: 'app/helper/', src: [ '**/*.coffee' ] }
          { expand: yes, cwd: 'app/models/', src: [ '**/*.coffee' ] }
          { expand: yes, cwd: 'tests/', src: [ '**/*.coffee' ] }
        ]

    csslint:
      options:
        import: 2
        'adjoining-classes': off
        'box-sizing': off
        'box-model': off
        'compatible-vendor-prefixes': off
        'floats': off
        'font-sizes': off
        'gradients': off
        'important': off
        'known-properties': off
        'outline-none': off
        'qualified-headings': off
        'regex-selectors': off
        'text-indent': off
        'unique-headings': off
        'universal-selector': off
        'unqualified-attributes': off
      client:
        files: [
          { expand: yes, cwd: '.tmp/', src: [ '**/*.styl' ] }
        ]

    htmlhint:
      options:
        'tag-pair': on
      client:
        files: [
          { expand: yes, cwd: '.tmp/', src: [ '**/*.html' ] }
        ]

    coffee:
      dist:
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '*.coffee', '**/*.coffee' ]
          dest: '.tmp/'
          ext: '.js'
        }]

    stylus:
      dist:
        options:
          compress: no
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '*.styl', '**/*.styl' ]
          dest: '.tmp/'
          ext: '.css'
        }]
      release:
        options:
          compress: yes
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '*.styl', '**/*.styl' ]
          dest: 'public/'
          ext: '.css'
        }]

    jade:
      dist:
        options:
          pretty: yes
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '*.jade', '**/*.jade' ]
          dest: '.tmp/'
          ext: '.html'
        }]
      release:
        options:
          pretty: no
        files: [{
          expand: yes
          cwd: 'app/assets/'
          src: [ '*.jade', '**/*.jade' ]
          dest: 'public/'
          ext: '.html'
        }]

    uglify:
      release:
        files: [{
          expand: yes
          cwd: '.tmp/'
          src: [ '*.js', '**/*.js' ]
          dest: 'public/'
          ext: '.js'
        }]

    simplemocha:
      options:
        ui: 'bdd'
        reporter: 'spec'
        compilers: 'coffee:coffee-script'
        ignoreLeaks: no
      all:
        src: [ 'tests/**/*.coffee' ]

    watch:
      options:
        livereload: yes
        interrupt: yes
        spawn: no
      coffee:
        tasks: [ 'concurrent:buildjs' ]
        files: [ 'app/assets/**/*.coffee' ]
      stylus:
        tasks: [ 'concurrent:buildcss' ]
        files: [ 'app/assets/**/*.styl' ]
      jade:
        tasks: [ 'concurrent:buildhtml' ]
        files: [ 'app/assets/**/*.jade' ]
      test:
        tasks: [ 'concurrent:test' ]
        files: [ 'app/**/*.coffee', '!app/assets' ]