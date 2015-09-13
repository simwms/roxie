defmodule Roxie.TicketView do
  use Roxie.Web, :view

  def render("index.json", %{tickets: tickets}) do
    %{data: render_many(tickets, Roxie.TicketView, "ticket.json")}
  end

  def render("show.json", %{ticket: ticket}) do
    %{data: render_one(ticket, Roxie.TicketView, "ticket.json")}
  end

  def render("ticket.json", %{ticket: ticket}) do
    %{id: ticket.signature,
      acl: ticket.acl,
      bucket: ticket.bucket,
      policy: ticket.policy,
      policy64: ticket.policy64,
      signature: ticket.signature,
      access_key_id: ticket.access_key_id,
      post_url: ticket.post_url,
      show_url: ticket.show_url,
      expires_at: ticket.expires_at}
  end
end
