const colors = require('tailwindcss/colors')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.html.erb',
    './app/components/**/*.html.erb',
    './app/components/**/*.rb'
  ],
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.neutral,
      indigo: colors.indigo,
      red: colors.rose,
      yellow: colors.amber,
      emerald: colors.emerald,
      orange: colors.orange,
      pink: {
        '50': '#fef2f3',
        '100': '#fde6e7',
        '200': '#fbd0d5',
        '300': '#f7aab2',
        '400': '#f27a8a',
        '500': '#ea546c',
        '600': '#d5294d',
        '700': '#b31d3f',
        '800': '#961b3c',
        '900': '#811a39',
      },
    },
    extend: {
      screens: {
        'print': {'raw': 'print'},
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
