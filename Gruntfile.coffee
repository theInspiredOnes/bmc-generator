'use strict'

module.exports = (grunt) ->
	require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

	grunt.initConfig
		buildDir: './build'
		srcDir: './src'
		tmpDir: './.tmp'
		pkg: grunt.file.readJSON 'package.json'
		src:
			coffee: '<%= srcDir %>/scripts/**/*.coffee'
			less: '<%= srcDir %>/styles/*.less'
			templates: '<%= srcDir %>/templates/**/*.tpl'
			#jade: 'jade/*.jade'
		clean:
			tmp: [ 
				'<%= tmpDir %>'
			]
			build: [ 
				'<%= buildDir %>'
			]

		recess:
			build:
				src: [ '<%= src.less %>' ],
				dest: '<%= buildDir %>/css/<%= pkg.name %>.css',
				options:
					compile: true
					compress: true

		coffee:
			build:
				options:
					bare: true
				files: [
					expand: true,
					cmd: 'coffee',
					src: [ '<%= src.coffee %>' ],
					dest: '.tmp/js/',
					ext: '.js'
				]

		concat:
			build:
				src: [
					'module.prefix'
					'.tmp/js/**/*.js'
					'module.suffix'
				]
				dest: '<%= tmpDir %>/js/<%= pkg.name %>.js'

		# Annotate angular sources
		ngmin:
			build:
				src: [ '<%= tmpDir %>/js/<%= pkg.name %>.js' ]
				dest: '<%= buildDir %>/js/<%= pkg.name %>.annotated.js'

		# Minify the sources!
		uglify:
			build:
				files:
					'<%= buildDir %>/js/<%= pkg.name %>.min.js': [ '<%= buildDir %>/js/<%= pkg.name %>.annotated.js' ]

		copy:
			templates:
				files: [
					cwd: '<%= srcDir %>/templates/'
					src: '**/*.tpl'
					dest: '<%= buildDir %>/templates/'
					expand: true
				]
			main: 
				files: [
					cwd: '<%= srcDir %>'
					src: 'index.html'
					dest: '<%= buildDir %>'
					expand: true
				]
			css:
				files: [
					cwd: '<%= srcDir %>/styles/vendor'
					src: '*.css'
					dest: '<%= buildDir %>/css'
					expand: true
				]
			js:
				files: [
					cwd: '<%= srcDir %>/scripts/vendor'
					src: '*.js'
					dest: '<%= buildDir %>/js'
					expand: true
				]


		delta:
			options:
				livereload: true
			# js:
			# 	files: [ '<%= src.js %>' ]
			# 	tasks: [
			# 		'concat'
			# 		'ngmin'
			# 		'uglify'
			# 	]
			templates:
				files: [ '<%= src.templates %>' ]
				tasks: [ 'copy:templates' ]
			main:
				files: [ '<%= srcDir %>/index.html' ]
				tasks: [ 'copy:main' ]
			css:
				files: [ '<%= srcDir %>/styles/vendor/*.css' ]
				tasks: [ 'copy:css' ]
			js:
				files: [ '<%= srcDir %>/scripts/vendor/*.js' ]
				tasks: [ 'copy:js' ]
			coffee:
				files: [ '<%= src.coffee %>' ]
				tasks: [
					'clean:tmp'
					'coffee'
					'concat'
					'ngmin'
					'uglify'
				]
			less:
				files: [ '<%= src.less %>' ]
				tasks: [ 'recess' ]



	grunt.renameTask 'watch', 'delta'
	grunt.registerTask 'watch', [
		'build'
		'delta'
	]

	# The default task is to build.
	grunt.registerTask 'default', [ 'build' ]
	grunt.registerTask 'build', [
		'clean'
		'copy'
		'recess'
		'coffee'
		'concat'
		'ngmin'
		'uglify'
	]
