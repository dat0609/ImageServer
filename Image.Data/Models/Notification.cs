namespace CityDiscoverTourist.Data.Models;

public class Notification : BaseEntity
{
    public string? Content { get; set; }
    public DateTime CreatedDate { get; set; }
    public int QuestId { get; set; }
    public Guid PaymentId { get; set; }

    public IList<NotifyUser> NotifyUsers { get; set; }

}