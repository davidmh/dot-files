{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "David Mejorado";
        email = "david.mejorado@gmail.com";
        signingkey = "86C60D761EB5F758";
      };

      alias = {
        current-branch = "rev-parse --abbrev-ref HEAD";
        default-branch = "config init.defaultBranch";
        fresh = "!git fetch origin $(git default-branch):$(git default-branch) && git switch $(git default-branch)";
        pushc = "!git push origin $(git current-branch)";
        pullc = "!git pull origin $(git current-branch)";
        amend-date = ''!LC_ALL=C GIT_COMMITTER_DATE="$(date)" git commit -n --amend --no-edit --date "$(date)"'';
      };

      init.defaultBranch = "main";
      rebase.autosquash = true;
      fetch.writeCommitGraph = true;
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      delta.side-by-side = true;
      delta.line-numbers = false;
    };

    lfs.enable = true;
  };

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 28800;
    pinentry.package = with pkgs; (
      if stdenv.isDarwin then
        pinentry_mac
      else
        pinentry-qt
    );
  };
}
