class Contact < ActionMailer::Base
  def contact(contact)
    @subject = 'Portfolio Contact'
    @body["message"] = contact.message
    @body["email"] = contact.email
    @body["sender"] = contact.name
    @recipients = Role.find_by_name('owner').users.first.profile.email
    @from = contact.email
    @sent_on = Time.now
    @headers = {}
  end
end
