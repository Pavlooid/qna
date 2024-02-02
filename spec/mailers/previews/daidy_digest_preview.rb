# Preview all emails at http://localhost:3000/rails/mailers/daidy_digest
class DaidyDigestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daidy_digest/digest
  def digest
    DaidyDigestMailer.digest
  end

end
