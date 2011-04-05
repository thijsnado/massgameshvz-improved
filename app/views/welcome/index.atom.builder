atom_feed do |feed|
  feed.title("HVZ Feed")
  feed.updated(@posts.first.created_at)

  for post in @posts
    feed.entry(post, :url => post_url(post)) do |entry|
      entry.title(post.title)
      entry.content(raw(RedCloth.new(post.body).to_html), :type => 'html')

      entry.author do |author|
        author.name("Massgames RSO")
      end
    end
  end
end