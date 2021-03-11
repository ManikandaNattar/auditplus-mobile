class Organization {
  final String name;

  get domain {
    return 'https://${this.name}.auditplus.io';
  }

  get avatar {
    return this.name.substring(0, 1).toUpperCase();
  }

  Organization(this.name);
}
