{
  myConfig,
  ...
}:
{
  myConfig = {
    workstation.includes = [
      myConfig.boot
    ];
    desktop.includes = [
      myConfig.workstation
    ];
  };
}
