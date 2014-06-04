module.exports = (grunt) ->

  # すべてのtaskを読み込む
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    paths:
      up: '../forUpload/'
      css: '../forUpload/css/'
      cssdist: 'dist/css/'
      cssconcat: 'dist/css/concat/'
      cssmin: 'dist/css/min/'
      images: '../forUpload/images/'
      imagesdist: 'dist/images/'
      imagesini: 'forIni/images/'
      less: 'forIni/less/'
    #less
    less:
      compile:
        files:[
          expand: true
          cwd: '<%= paths.less %>'
          src: ['*.less']
          dest: '<%= paths.cssdist %>'
          ext: '.css'
        ]
    #concat
    concat:
      compile:
        src: ["<%= paths.cssdist %>*.css"]
        dest: "<%= paths.cssconcat %>common.css"
    #min
    cssmin:
      compile:
        expand: true
        cwd: '<%= paths.cssconcat %>'
        src: ['*.css']
        dest: '<%= paths.cssmin %>'
        ext: '.min.css'
        # IEハック用のCSSが消えないように設定
        options:
          noAdvanced: true
    #画像の圧縮
    imagemin:
      dynamic:
        files:[
          expand: true
          cwd: '<%= paths.imagesini %>'
          src: ['**/*.{jpg,png,gif,jpeg}']
          dest: '<%= paths.imagesdist %>'
        ]
    #監視用の設定
    watch:
      options:
        livereload: true
      less:
        files: '<%= paths.less %>*.less'
        #grunt.registerTask 'build'が実行される
        tasks: ['build']
    #buildしたファイルなどをuploadにcopy
    copy:
      up:
        files: [
          expand: true
          cwd: '<%= paths.cssmin %>'
          src: ['*.min.css']
          dest: '<%= paths.css %>'
        ],
      dev:
        files: [
          expand: true
          cwd: '<%= paths.cssconcat %>'
          src: ['*.css']
          dest: '<%= paths.css %>'
        ],
      images:
        files:[
          expand: true
          cwd: '<%= paths.imagesdist %>'
          src: ['*']
          dest: '<%= paths.images %>'
        ]
    #htmlファイルのdev用のcssを本番用に置換
    replace:
      dev:
        src: ['<%= paths.up %>*.html']
        overwrite: true
        replacements: [
          from: 'href="css/common.min.css"',
          to: 'href="css/common.css"'
        ]
      up:
        src: ['<%= paths.up %>*.html']
        overwrite: true
        replacements: [
          from: 'href="css/common.css"',
          to: 'href="css/common.min.css"'
        ]
    #不要なファイルの削除
    clean:
      options:
        # カレントディレクトリ外のファイルの削除を許可
        force: true
      up:
        src: ["<%= paths.css %>common.css"]
      dev:
        src: ["<%= paths.css %>common.min.css"]
    #browserSync
    browserSync:
      dev:
        bsFiles:
          src: [
            '<%= paths.up %>index.html',
            '<%= paths.up %>page2.html',
            '<%= paths.up %>css/*css'
          ]
        options:
          #watchが実行されてから
          watchTask: true
          # startPath: '<%= paths.up %>index.html'
          server:
            baseDir: '<%= paths.up %>'
            index: 'index.html'
          ghostMode:
            scroll: true
            links: true
            forms: true

  #aliases
  #指定したtaskを順に実行する
  #default => $ grunt のデフォルト
  grunt.registerTask 'sync', [
    'browserSync', 'watch'
  ]
  grunt.registerTask 'default', [
    'watch'
  ]
  grunt.registerTask 'image', [
    'imagemin', 'copy:images'
  ]
  grunt.registerTask 'build', [
    'less:compile', 'concat:compile', 'copy:dev', 'replace:dev'
  ]
  grunt.registerTask 'dev', [
    'less:compile', 'concat:compile', 'copy:dev', 'replace:dev', 'clean:dev'
  ]
  grunt.registerTask 'up', [
    'less:compile', 'concat:compile', 'cssmin:compile', 'copy:up', 'replace:up', 'clean:up'
  ]
