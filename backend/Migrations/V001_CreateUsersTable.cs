using FluentMigrator;

namespace backend.Migrations;

[Migration(1)]
public class V001_CreateUsersTable : Migration
{
    private const string TableName = "TB_USERS";

    public override void Up()
    {
        Create.Table(TableName)
            .WithColumn("ID_USER").AsInt32().Identity().PrimaryKey("PK_TB_USERS")
            .WithColumn("NM_USER").AsString(100).NotNullable()
            .WithColumn("DS_EMAIL").AsString(120).NotNullable()
            .WithColumn("DS_PASSWORD").AsString(255).NotNullable();
        
        Create.UniqueConstraint("UQ_TB_USERS_EMAIL")
            .OnTable(TableName)
            .Column("DS_EMAIL");
        
        Create.Index("IX_TB_USERS_EMAIL")
            .OnTable(TableName)
            .OnColumn("DS_EMAIL")
            .Ascending()
            .WithOptions().Unique();
    }

    public override void Down()
    {
        Delete.Table(TableName);
    }
}