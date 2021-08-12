const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')

const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
  ClipboardJS: 'clipboard',
  EasyMDE: 'easymde',
  select2: 'select2',
  selectpicker: 'selectpicker',
  d3: 'd3'
}));

environment.loaders.prepend('erb', erb)
module.exports = environment
