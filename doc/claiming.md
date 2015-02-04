Claiming ownership of a certificate
===================================

Sign in or create an account
----------------------------

First you will need to create an account. Unless you have found a dataset on
Open Data Certificate that is yours in which case an account may have been
created for you if the description of your dataset includes the correct email
address.

If the email address of your account matches that in the publisher’s contact
details then you will already have control of the certificates and don’t need
to do anything further.

Claim a certificate
-------------------

![Certificate view][image_certificate]

When you visit a certificate page there will be an option to claim a dataset if
it is yours. To the right of the certificate header with the label “Is this
dataset yours?”.

![Claim certificate popup][image_popup]

When you request ownership of a certificate then either an administrator at The
ODI will assess your claim or the current owner of the certificate can agree to
transfer ownership.

When the request has either been approved or denied you will get an email
informing you and linking you to the page so you can update information on the
certificate.


Responding to a claim
=====================

When a user makes a claim for a certificate then the `certificate@theodi.org` account will receive an email

    To: certificate@theodi.org
    From: certificate@theodi.org
    Subject: Certificate ownership transfer: 34

    You have been asked to hand over ownership of an Open Data Certificate.
    Please visit http://certificates.theodi.org/claims to accept or deny this claim.

You will then be able to approve or deny the requests.

![Claims index view][image_claims]

Who is notified
---------------

Currently only `certificate@theodi.org` is notified though all admins and the
current owner of the certificate have the ability to approve or deny the claim.

There is a setting in [Claim][admin_override] that can be changed or removed
and then only the owner of the certificate will be notified.

[admin_override]: https://github.com/theodi/open-data-certificate/blob/master/app/models/claim.rb#L4
[image_certificate]: images/claiming/certificate.png
[image_popup]: images/claiming/popup.png
[image_claims]: images/claiming/claims.png
