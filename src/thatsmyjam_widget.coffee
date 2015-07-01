$ = (el) -> document.getElementById(el)

window.App = {}

App.Errors =
  noTemplateUrl: 'div with id "thisismyjam" must have a data-template-url property with the location of the Mustache template'
  noUsername: 'div with id "thisismyjam" must contain the desired thisismyjam username'

App.Templates = {}

App.TemplateManager = ->
  return {
    tmj:
      $('thisismyjam')

    retrieveTemplate: ->
      throw new Error(App.Errors.noTemplateUrl) unless @tmj.dataset.templateUrl

      req = new XMLHttpRequest()
      req.onload = ->
        script = document.createElement('script')
        script.innerHTML = this.responseText
        App.Templates.mustacheTemplate = script
      templateUrl = @tmj.dataset.templateUrl
      req.open('GET', templateUrl, { async: false})
      req.send()
  }


Jam = (request) ->
  return {
    initRequest: ->
      throw new Error(App.Errors.noUsername) unless $('thisismyjam').dataset.templateUrl

      uName = $('thisismyjam').dataset.tmjUsername
      request.open('GET', "https://api.thisismyjam.com/1/#{uName}.json", { async: false })

    sendRequest: ->
      @initRequest()
      request.send()
      this

    populateDom: ->
      self = @
      request.addEventListener 'loadend', ->
        if @status is 200 && @response
          resp = self.responseAsJSON(@response)
          rendered = Mustache.render(App.Templates.mustacheTemplate.innerHTML, resp)
          $('thisismyjam').innerHTML = rendered
          self.reformatDate(resp)
        if resp.person.hasCurrentJam
          $('noJam').innerHTML = ''
        else
          $('hasJam').innerHTML = ''


    responseAsJSON: (resp) ->
      JSON.parse(resp)

    reformatDate: (resp) ->
      dateEl = $('jam-creation-date')
      newDate = resp.jam?.creationDate.split(' ').slice(0, 4).join(' ')
      dateEl.innerHTML = newDate
    }

App.templateManager = new App.TemplateManager()
App.templateManager.retrieveTemplate()

req = new XMLHttpRequest()
App.jam = new Jam(req)
App.jam.sendRequest().populateDom()
