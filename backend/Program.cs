using backend.Data;
using FluentMigrator.Runner;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var migrationConnectionString = Environment.GetEnvironmentVariable("CONNSTR_MIGRATIONS") ?? throw new InvalidOperationException("A variável de ambiente 'CONNSTR_MIGRATIONS' não está definida!");
var applicationConnectionString = Environment.GetEnvironmentVariable("CONNSTR_APPLICATION") ?? throw new InvalidOperationException("A variável de ambiente 'CONNSTR_APPLICATION' não está definida!");

builder.Services
    .AddFluentMigratorCore()
    .ConfigureRunner(r => r.AddSqlServer().WithGlobalConnectionString(migrationConnectionString)
            .ScanIn(typeof(Program).Assembly).For.Migrations()
    ).AddLogging(lb => lb.AddFluentMigratorConsole());

builder.Services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(applicationConnectionString));


var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var migrator = scope.ServiceProvider.GetRequiredService<IMigrationRunner>();
    var migrationInfos = migrator.MigrationLoader.LoadMigrations();

    if (migrationInfos.Count != 0)
    {
         migrator.MigrateUp();   
    }
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapControllers();

app.Run();