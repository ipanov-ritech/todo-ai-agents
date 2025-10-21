using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ReactReduxTodo.Entities;

public class Category
{
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required]
    [MaxLength(7)] // #RRGGBB format
    public string Color { get; set; } = string.Empty;

    public DateTime CreatedDate { get; set; }

    // Navigation property
    public ICollection<TodoTask> Tasks { get; set; } = new List<TodoTask>();
}
