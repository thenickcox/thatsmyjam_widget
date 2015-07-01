describe 'TemplateManager', ->
  describe 'retrieveTemplate', ->

    context 'correctly formed HTML element', ->
      it 'retrieves a mustache template', ->
        expect(App.Templates.mustacheTemplate.innerHTML).to.contain '<p class=\'listening-to\'>My current jam:</p>'

    context 'incorrectly formed HTML element', ->
      context 'no templateurl', ->
        beforeEach ->
          div = document.getElementById('thisismyjam')
          delete div.dataset.templateUrl
        it 'throws an error', ->
          expect(->
            App.templateManager.retrieveTemplate()
          ).to.throw(App.Errors.noTemplateUrl)


describe 'Jam', ->
  describe 'initRequest', ->
    context 'no username', ->
      beforeEach ->
        div = document.getElementById('thisismyjam')
        delete div.dataset.tmjUsername
      it 'throws an error', ->
        expect(->
          App.jam.initRequest()
        ).to.throw(App.Errors.noUsername)
