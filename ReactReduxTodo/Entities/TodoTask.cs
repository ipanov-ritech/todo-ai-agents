namespace ReactReduxTodo.Entities;

public class TodoTask
{
    public int Id { get; set; }
    public string? Description { get; set; }

    // Category relationship
    public int? CategoryId { get; set; }
    public Category? Category { get; set; }
}