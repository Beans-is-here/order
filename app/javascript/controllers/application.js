import { Application } from "@hotwired/stimulus"
import { Autocomplete } from 'stimulus-autocomplete'
// コンポーネントを読み込み

const application = Application.start()
application.register('autocomplete', Autocomplete)
// コンポーネントにあるAutocompleteコントローラを使えるようにするための記述
// Configure Stimulus development experience
application.debug = false //true
window.Stimulus   = application

export { application }
