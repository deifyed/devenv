FROM archlinux:base-devel

# Enter shell on start
ENTRYPOINT ["/bin/zsh"]

# Add my user
RUN useradd -m dev

# Install packages
RUN pacman -Syu --noconfirm && \
    # Basic packages
    pacman -S zsh openssh keychain git neovim --noconfirm && \
    # Dependencies
    pacman -S go npm unzip --noconfirm && \
    # Nice to haves
    pacman -S fzf tree bat exa kubectl --noconfirm

# Change to user
USER dev
WORKDIR /home/dev

# Hack to get zsh to work due to dependency
RUN echo "" >> ~/.aliases.secret

# Prepare git
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Prepare folders
RUN \
    mkdir -p ~/.config && \
    mkdir -p ~/.local/{src,share}

# Install oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Fetch necessary files
RUN \
    git clone https://github.com/rupa/z.git ~/.local/src/z && \
    git clone https://github.com/deifyed/vim ~/.config/nvim && \
    git clone https://github.com/deifyed/dotfiles.git ~/.local/src/dotfiles && \
    sh ~/.local/src/dotfiles/infect.sh

# Init vim
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' > /dev/null 2>&1
