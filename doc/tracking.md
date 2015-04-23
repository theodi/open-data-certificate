Google Analytics tracking
=========================

Event tracking
--------------

### Modal dialogs

Most modal dialogs on the site should trigger
either a `show` or `hide` action under the
`Popup` category with the `id` of the dialog
as the `label`.

### Search

If the advanced search are shown then a
`toggle` action should be recorded under the
`Search` category.

### Homepage

If the questionnaire creation options are used
a `change-jurisdiction` event will be triggered
for each choice and a `create-with-jurisdiction`
event will be triggered on pressing the create
button.

### Questionnaire

These actions are recorded with `Questionnaire`
as the category.

#### Sections

Sections that are collapsed or shown trigger
`show` or `hide` actions with the `id` of the
section as the `label`.

#### Saving

A survey goes through a series of events when
it is started. On the documentationUrl question
page the event action `begin` will be triggered.
With the same identifier code that is in the url
as the `label`.

Once the user continues to the questionnaire page
then a `continue` action will happen.

`save` will happen after pressing the `Save and finish`
button and the user ends up on the dashboard page.

`publish` is the final event after the `Publish certificate`
button.

#### Scrolling

Scroll events are recorded when the user moves down
the page significantly. The action is `scroll` with
a label of `page` and the `value` is the percentage
down the page the browser is scrolled.

#### Last question

If the user leaves the page by some other means
than pressing the `Save and finish` button then
the last question they clicked on should be recorded
with `last-question` as the action, the text text
of the question as the `label` and the database id
of the question as the `value`.

### Summary of events

<table>
  <thead>
    <tr>
      <th>Category</th>
      <th>Action</th>
      <th>Label</th>
      <th>Value</th>
    </tr>
  </thead>
<tbody>
  <tr>
    <td rowspan=2>Popup</td>
    <td>show</td>
    <td>modal-id-value</td>
    <td></td>
  </tr>
  <tr>
    <td>hide</td>
    <td>modal-id-value</td>
    <td></td>
  </tr>
  <tr>
    <td>Search</td>
    <td>toggle</td>
    <td>advanced-options</td>
    <td></td>
  </tr>
  <tr>
    <td rowspan=8>Questionnaire</td>
    <td>show</td>
    <td rowspan=2>section-id</td>
    <td></td>
  </tr>
  <tr>
    <td>hide</td>
    <td></td>
  </tr>
  <tr>
    <td>begin</td>
    <td rowspan=4>response set access code</td>
    <td></td>
  </tr>
  <tr>
    <td>continue</td>
    <td></td>
  </tr>
  <tr>
    <td>save</td>
    <td></td>
  </tr>
  <tr>
    <td>publish</td>
    <td></td>
  </tr>
  <tr>
    <td>scroll</td>
    <td>page</td>
    <td>percentage of page viewed</td>
  </tr>
  <tr>
    <td>last-question</td>
    <td>question text</td>
    <td>question id</td>
  </tr>
  <tr>
    <td rowspan=2>Homepage</td>
    <td>change-jurisdiction</td>
    <td rowspan=2>country-code</td>
    <td></td>
  </tr>
  <tr>
    <td rowspan=2>Homepage</td>
    <td>create-with-jurisdiction</td>
    <td></td>
  </tr>
</tbody>
</table>
