using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace ReactReduxTodo.Migrations
{
    /// <inheritdoc />
    public partial class AddCategories : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "CategoryId",
                table: "TodoTasks",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Color = table.Column<string>(type: "nvarchar(7)", maxLength: 7, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                });

            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "Color", "CreatedDate", "Name" },
                values: new object[,]
                {
                    { 1, "#3498db", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Work" },
                    { 2, "#2ecc71", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Personal" },
                    { 3, "#e74c3c", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Shopping" },
                    { 4, "#9b59b6", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Health" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_TodoTasks_CategoryId",
                table: "TodoTasks",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_TodoTasks_Categories_CategoryId",
                table: "TodoTasks",
                column: "CategoryId",
                principalTable: "Categories",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TodoTasks_Categories_CategoryId",
                table: "TodoTasks");

            migrationBuilder.DropTable(
                name: "Categories");

            migrationBuilder.DropIndex(
                name: "IX_TodoTasks_CategoryId",
                table: "TodoTasks");

            migrationBuilder.DropColumn(
                name: "CategoryId",
                table: "TodoTasks");
        }
    }
}
